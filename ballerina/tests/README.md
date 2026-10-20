# Tests

The test suite covers the 25 operations served by the mock: listing, retrieving, creating, replacing and deleting inventory items, inventory item groups and product compatibility; bulk get, create and price/quantity updates; creating, updating, deleting, publishing and withdrawing offers; previewing listing fees; and managing inventory locations.

## Running Tests

```bash
bal test
```

By default the tests run against a mock server (`tests/mock_service.bal`) on `http://localhost:9090`, so no real credentials are required.

To run the tests tagged `live_tests` against the real eBay API, set the following environment variables and run the live group:

| Variable | Purpose |
|---|---|
| `IS_LIVE_SERVER` | Set to `true` to target `https://api.ebay.com/sell/inventory/v1` |
| `EBAY_ACCESS_TOKEN` | eBay user access token with the `sell.inventory` scope |
| `EBAY_TEST_SKU` | An existing SKU that has an inventory item, product compatibility and an offer |

```bash
IS_LIVE_SERVER=true bal test --groups live_tests
```
