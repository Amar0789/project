terraform{
    required_providers{
        aws = {
            source = "hashicorp/aws"
            version = "5.66.0"
        }
    }

    backend "s3"{
        bucket = "myapp789bucket"
        key = "demo"
        dynamodb_table = "testing"
        region = "us-east-1"

    }

}
