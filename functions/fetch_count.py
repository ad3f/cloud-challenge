import boto3
import os

client = boto3.resource('dynamodb')
tableName = os.environ['TABLE_NAME']
table = client.Table(tableName)

def lambda_handler(event, context):
    
    res = table.get_item(Key = {'DB_ITEM' : 'visitors'})
    
    if "Item" in res:
        counter = res["Item"]["CALC_TOTAL"]
    else:
        counter = 0

    data = {
        'statusCode': 200,
        'body' : counter,
        'headers': {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*'
      },
    }
  
    return data