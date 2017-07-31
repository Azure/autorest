var suppressionContract = new SuppressionContract
{
    Ttl = "07:00:00:00"
};
await client.Suppressions.CreateAsync(
    resourceUri: "resourceUri",
    recommendationId: "recommendationId",
    name: "suppressionName1",
    suppressionContract: suppressionContract);
