[
    {
        "name": "spitlog",
        "image": "${aws_ecr_url}:${tag}",
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "${cloudwatch_log_group_name}",
                "awslogs-region": "${aws_region}",
                "awslogs-stream-prefix": "${cloudwatch_log_prefix}"
            }
        }
    }
]