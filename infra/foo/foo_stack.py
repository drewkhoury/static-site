from aws_cdk import core


class FooStack(core.Stack):

    def __init__(self, scope: core.Construct, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)

        # The code that defines your stack goes here

        # node code that needs to be changed to python





# # s3 bucket
# siteBucket = new s3.Bucket staticSiteBucket
# websiteIndexDocument: 'index.html',
# publicReadAccess: false,
# blockPublicAccess: s3.BlockPublicAccess.BLOCK_ALL,
# removalPolicy: RemovalPolicy.DESTROY,
# autoDeleteObjects: true,

# # cdk deploy: deploys your app into an AWS account
# # cdk synth: synthesizes an AWS CloudFormation template for your app
# # cdk diff: compares your app with the deployed stack

# # variables
# hostedZoneId=APP_HOSTED_ZONE_ID
# hostedZoneName=APP_HOSTED_ZONE_NAME
# siteDomain=APP_DOMAIN

# # create a zone    
# zone = route53.HostedZone.fromHostedZoneAttributes zone
# zoneName
# hostedZoneId

# # CF OriginAccessIdentity
# cloudfrontOAI = cloudfront.OriginAccessIdentity cloudfront-OAI
# comment: `OAI for ${siteDomain}`

# # s3 bucket
# siteBucket = new s3.Bucket staticSiteBucket
# websiteIndexDocument: 'index.html',
# publicReadAccess: false,
# blockPublicAccess: s3.BlockPublicAccess.BLOCK_ALL,
# removalPolicy: RemovalPolicy.DESTROY,
# autoDeleteObjects: true,


# # Grant access to cloudfront by attaching policy to bucket
# siteBucket.addToResourcePolicy iam.PolicyStatement
# {
# actions: ['s3:GetObject'],
# resources: [siteBucket.arnForObjects('*')],
# principals: [new iam.CanonicalUserPrincipal(cloudfrontOAI.cloudFrontOriginAccessIdentityS3CanonicalUserId)]
# }
# new CfnOutput(this, 'Bucket', { value: siteBucket.bucketName });

# # create cert
# certificate = new acm.DnsValidatedCertificate SiteCertificate
# domainName: siteDomain,
# subjectAlternativeNames: [apiDomain],
# hostedZone: zone,
# region: 'us-east-1', # Cloudfront only checks this region for certificates.
# const certificateArn = certificate.certificateArn;
# new CfnOutput(this, 'Certificate', { value: certificateArn });

# # CloudFront distribution
# distribution = cloudfront.CloudFrontWebDistribution SiteDistribution
# viewerCertificate: {
#     aliases: [siteDomain],
#     props: {
#     acmCertificateArn: certificateArn,
#     sslSupportMethod: "sni-only",
#     },
# },
# originConfigs: [
# {
#     s3OriginSource: {
#     s3BucketSource: siteBucket,
#     originAccessIdentity: cloudfrontOAI
#     },
#     behaviors: [{
#     isDefaultBehavior: true,
#     compress: true,
#     allowedMethods: cloudfront.CloudFrontAllowedMethods.GET_HEAD_OPTIONS,
#     }],
# }
# ]
# new CfnOutput(this, 'DistributionId', { value: distribution.distributionId });

# # DNS alias/arecord
# route53.ARecord SiteAliasRecord
# recordName: siteDomain,
# target: route53.RecordTarget.fromAlias(new targets.CloudFrontTarget(distribution)),
# zone

# # S3 Deployment
# s3_deployment.BucketDeployment DeployWithInvalidation
# sources: [s3_deployment.Source.asset('../frontend/public')],
# destinationBucket: siteBucket,
# distribution,
# distributionPaths: ['/*'],
# memoryLimit: 512


