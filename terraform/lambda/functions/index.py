import json
import boto3
import os

client = boto3.resource('dynamodb')
tableName = os.environ['TABLE_NAME']
table = client.Table(tableName)


def lambda_handler(event, context):
  
    table.update_item(
    Key={
        'DB_ITEM': 'visitors',
    },
    UpdateExpression='SET CALC_TOTAL = CALC_TOTAL + :val1',
    ExpressionAttributeValues={
        ':val1': 1
    }
    )
    response = table.get_item(
      Key = {
        'DB_ITEM' : 'visitors'
      }
    )

    data = {
        'statusCode': 200,
        'body': json.dumps(str(response.get('Item').get('CALC_TOTAL'))),
        'headers': {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*'
      },
    }
  
    return data