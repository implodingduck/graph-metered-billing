#!/bin/bash

source .env

# Get an Entra ID token for the Microsoft Graph API
TOKEN=$(curl -s -X POST \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=${AZURE_CLIENT_ID}" \
  -d "scope=https://graph.microsoft.com/.default" \
  -d "client_secret=${AZURE_CLIENT_SECRET}" \
  -d "grant_type=client_credentials" \
  "https://login.microsoftonline.com/${AZURE_TENANT_ID}/oauth2/v2.0/token" | jq -r '.access_token')
# Check if the token was retrieved successfully
if [ -z "$TOKEN" ]; then
  echo "Failed to retrieve access token."
  exit 1
fi


curl -s -X GET \
  -H "Authorization: Bearer ${TOKEN}" \
  "https://graph.microsoft.com/v1.0/users/${MY_OBJECT_ID}/onlineMeetings/?\$filter=JoinWebUrl%20eq%20'${JOINURL}'" | jq '.'





#/users/{userId}/onlineMeetings/{meetingId}