def lambda_url_test(event, context):
    print ("Welcome to Lambda URL test function")
    print("Event-> ",event)
    print("Context-> ",context)
    return "Hello World -  Message form Lambda"