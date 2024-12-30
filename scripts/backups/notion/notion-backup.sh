#!/bin/bash
# usage ./notion-backup.sh [output_dir]

test -x "$(which curl)" || exit 1
test -x "$(which jq)" || exit 1

die() {
  echo "$1" >&2
  exit 1
}

DIR="$(dirname "$(readlink -f "$0")")"
. "$DIR"/.env

if [ -z "$NOTION_TOKEN" ] || [ -z "$NOTION_FILE_TOKEN" ] || [ -z "$NOTION_SPACE_ID" ]; then
  die "Need to have NOTION_TOKEN, NOTION_FILE_TOKEN, and NOTION_SPACE_ID defined."
fi

exportFromNotion() {
  local format="$1"
  local resultPath="$2"
  local notionAPI="https://www.notion.so/api/v3"
  local exportURL

  enqueueTaskResponse=$(curl -s -X POST -H "Cookie: token_v2=$NOTION_TOKEN; file_token=$NOTION_FILE_TOKEN" -H "Content-Type: application/json" -d '{"task":{"eventName":"exportSpace","request":{"spaceId":"'"$NOTION_SPACE_ID"'","exportOptions":{"exportType":"'"$format"'","timeZone":"UTC","locale":"en"},"shouldExportComments":false}}}' "$notionAPI/enqueueTask")

  echo "$enqueueTaskResponse"
  taskId=$(echo "$enqueueTaskResponse" | jq -r '.taskId')

  echo "Enqueued task $taskId"

  failCount=0
  while true; do
    if [ "$failCount" -ge 5 ]; then
      break
    fi

    sleep 10

    getTasksResponse=$(curl -s -X POST -H "Cookie: token_v2=$NOTION_TOKEN; file_token=$NOTION_FILE_TOKEN" -H "Content-Type: application/json" -d '{"taskIds":["'"$taskId"'"]}' "$notionAPI/getTasks")

    taskState=$(echo "$getTasksResponse" | jq -r '.results[] | select(.id == "'"$taskId"'") | .state')
    taskStatusPagesExported=$(echo "$getTasksResponse" | jq -r '.results[] | select(.id == "'"$taskId"'") | .status.pagesExported')
    taskError=$(echo "$getTasksResponse" | jq -r '.results[] | select(.id == "'"$taskId"'") | .error')

    if [ -z "$taskState" ]; then
      failCount=$((failCount+1))
      echo "No task, waiting."
      continue
    fi

    if [ "$taskState" == "in_progress" ]; then
      echo "Pages exported: $taskStatusPagesExported"
    fi

    if [ "$taskState" == "failure" ]; then
      failCount=$((failCount+1))
      echo "Task error: $taskError"
      continue
    fi

    if [ "$taskState" == "success" ]; then
      exportURL=$(echo "$getTasksResponse" | jq -r '.results[] | select(.id == "'"$taskId"'") | .status.exportURL')
      break
    fi
  done

  if [ -z "$exportURL" ]; then
    die "Failed to get export URL"
  fi

  curl -s -H "Cookie: token_v2=$NOTION_TOKEN; file_token=$NOTION_FILE_TOKEN" -o "$resultPath" "$exportURL"
}

run() {
  cwd="${1:-notion-backup}"
  mkdir -p "$cwd"
  mdDir="$cwd/markdown"
  mdFile="$cwd/markdown.zip"

  if [ -f "$mdFile" ]; then
    mv "$mdFile" "$mdFile"_old
  fi

  echo "Exporting to $mdFile"
  exportFromNotion "markdown" "$mdFile"

  if [ -f "$mdDir"_old ] && [ -f "$mdFile" ]; then
    rm "$mdDir"_old
  fi
}

run "$1"
