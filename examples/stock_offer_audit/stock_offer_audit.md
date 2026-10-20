# Stock offer audit

This example pages through every inventory item of a seller account, checks the offers of each SKU and reports the SKUs that have no published offer, together with the number of inventory locations.

## Prerequisites

- Ballerina Swan Lake 2201.12.0 or later
- An eBay OAuth user access token with the `https://api.ebay.com/oauth/api_scope/sell.inventory.readonly` scope
- Create a `Config.toml` in this directory:
  ```toml
  accessToken = "<ebay-user-access-token>"
  pageSize = 100
  ```

## Run the example

```bash
bal run
```
