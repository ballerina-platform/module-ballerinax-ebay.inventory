_Author_:  @DimuthuMadushan \
_Created_: 2026/10/20 \
_Updated_: 2026/10/20 \
_Edition_: Swan Lake

# Sanitation for OpenAPI specification

This document records the sanitation done on top of the official OpenAPI specification from eBay Inventory. 
The OpenAPI specification is obtained from [wso2/api-specs](https://github.com/wso2/api-specs/blob/main/openapi/ebay/inventory/1.18.8/openapi.json).
These changes are done in order to improve the overall usability, and as workarounds for some known language limitations.

1. Changed the OpenAPI version from `3.1.0` to `3.0.3`. With `3.1.0`, `bal openapi flatten` replaces every inline parameter schema (path, query and header) with an empty schema, so all 23 operations with a path parameter were dropped from the generated client (13 of 36 remained). The spec uses no 3.1-only constructs. Made in the original spec `docs/spec/openapi.json`.

2. Changed the 21 enumeration schemas (`AvailabilityTypeEnum`, `ConditionEnum`, `CountryCodeEnum`, `CurrencyCodeEnum`, `DayOfWeekEnum`, `FormatTypeEnum`, `LengthUnitOfMeasureEnum`, `ListingDurationEnum`, `ListingStatusEnum`, `LocaleEnum`, `MarketplaceEnum`, `MinimumAdvertisedPriceHandlingEnum`, `OfferStatusEnum`, `PackageTypeEnum`, `ResponsiblePersonTypeEnum`, `ShippingServiceTypeEnum`, `SoldOnEnum`, `StatusEnum`, `StoreTypeEnum`, `TimeDurationUnitEnum`, `WeightUnitOfMeasureEnum`) from `type: object` to `type: string`. They declare an `enum` list of string values, so the object type generated open `record {}` types instead of string unions. Made in the original spec `docs/spec/openapi.json`.

3. Added the missing operation summaries (all 36), descriptions for the successful responses that carried only a generic `Success` or `Created`, and descriptions for the `ErrorParameter` schema and the `createOrReplaceSkuLocationMapping` request body.

4. Replaced the templated server URL `https://api.ebay.com{basePath}` (with a `basePath` variable defaulting to `/sell/inventory/v1`) with the plain URL `https://api.ebay.com/sell/inventory/v1`, so the generated client's default `serviceUrl` equals the spec's server URL.

5. Removed the deprecated properties, which apply only to the STORE location type that eBay no longer supports: `pickupAtLocationAvailability` from `Availability` and `AvailabilityWithAll`; `locationInstructions`, `operatingHours` and `specialHours` from `InventoryLocation`, `InventoryLocationFull` and `InventoryLocationResponse`; and `phone` from `InventoryLocationResponse`, including its entry in that schema's `required` list. Then removed the schemas that only those properties referenced: `AvailabilityTypeEnum`, `Interval`, `OperatingHours`, `PickupAtLocationAvailability` and `SpecialHours`. The deprecated schemas were referenced from other generated types, so every build of the package emitted deprecation warnings, and the required deprecated `phone` would have failed data binding for responses that leave it out.

6. Changed the `aspects` property of `Product` and `InventoryItemGroup` from `type: string` to an object with string-array values (`additionalProperties: {type: array, items: {type: string}}`). eBay sends and accepts aspects as name-value pairs such as `{"Brand": ["GoPro"], "Color": ["Black"]}`, so the string type could neither carry the item specifics needed to publish an offer nor bind them in responses.

7. Removed the vendor HTML (`<br>`, `<strong>`, `<a>`, `<code>`, `<span class="tablenote">` and so on) from the descriptions and summaries, leaving plain text, and simplified the descriptions longer than 200 characters (51 schemas, 182 properties, 25 parameters and 33 operations) into short summaries that keep the requirements, limits, defaults and formats.

## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

```bash
bal openapi -i docs/spec/aligned_ballerina_openapi.json -o ballerina --mode client --client-methods remote --license docs/license.txt
```

Note: The license year is hardcoded to 2024, change if necessary.
