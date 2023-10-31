# Risk 

-> API

```
http://localhost:3000/api/v1/purchases

### success

request:
{
 "transaction_id" : 2342357,
 "merchant_id" : 29744,
 "user_id" : 97051,
 "card_number" : "434505******9116",
 "transaction_date" : "2019-11-31T23:16:32.812632",
 "transaction_amount" : 373,
 "device_id" : 285475
}

response:
{
	"transaction_id": 2342357,
	"recommendation": "approve"
}

status: 202
```
### fail
```
request:
{
"transaction_id" : 213230492,
"merchant_id" : 49919,
"user_id" : 78262,
"card_number" : "434505******9116",
"transaction_date" : "2019-11-31T23:16:32.812632",
"transaction_amount" : 373,
"device_id" : 285475

}

response:
{
	"transaction_id": 213230492,
	"recommendation": "deny"
}
status: 402
```

 ### answers:

3.1.1 the flow is usually customer -> merchant -> acquirer -> card networks -> issuer.
    - The customer will purchase with the merchant. The merchant sends the payment transaction data to the acquirer. The acquirer will check with the Issuer if it is approved and return the information in the flow back. 
3.1.2 The acquirer enables the merchant the possibility to accept the payments but, in general, is a huge institutional bank. 
Sub-acquirer can facilitate the way for merchants to provide services and features. The gateway is the bridge. The main responsibility is to handle the data that the user sends. In addition, all companies can have policies to prevent fraud and depend on the contract with the merchant.


3.1.3 - chargeback occurs when the customer opens some dispute about any transaction for a fraud suspect. If it happens, the user needs to prove that he is right. Cancellations occur when the customer decides to stop giving up buying in-store, which is more friendly. This differs from the chargeback, where the acquirer should moderate and understand who is wrong.
Both can be connected with Fraud, but we must understand and investigate all the scenes.

3.2 - We can watch a few patterns in the fraud environment: many purchases in a short period outside events like Black Friday and Christmas. One good pattern is that the product prices usually will scale up, using different stores and many cards. Unfortunately, there are many patterns and types of fraud, and as part of the process, we can set up the application to allow it manually.

