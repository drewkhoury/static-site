from aws_cdk import CfnOutput, Stack
from static_site import StaticSitePrivateS3


class StaticSiteStack(Stack):
    def __init__(self, scope, construct_id, props, **kwargs):
        super().__init__(scope, construct_id, **kwargs)

        site_domain_name = props["domain_name"]
        if props["sub_domain_name"]:
            site_domain_name = (
                f'{props["sub_domain_name"]}.{props["domain_name"]}'
            )

        #  creates a private S3 as the origin
        site = StaticSitePrivateS3(
            self,
            f"{props['namespace']}-construct",
            site_domain_name=site_domain_name,
            domain_certificate_arn=props["domain_certificate_arn"],
            hosted_zone_id=props["hosted_zone_id"],
            hosted_zone_name=props["hosted_zone_name"],
        )

        # Add stack outputs
        CfnOutput(
            self,
            "SiteBucketName",
            value=site.bucket.bucket_name,
        )
        CfnOutput(
            self,
            "DistributionId",
            value=site.distribution.distribution_id,
        )
        CfnOutput(
            self,
            "CertificateArn",
            value=site.certificate.certificate_arn,
        )