provider "aws" {
  region = "us-west-2"
}

# IAM Role for ECS Task Execution
resource "aws_iam_role" "ecs_execution_role" {
  name = "ecs_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
      },
    ],
  })
}

// ECS cluster
resource "aws_ecs_cluster" "enron_cluster" {
  name = "enron-cluster"
}

// Task definition for the ZincSearch container
resource "aws_ecs_task_definition" "zincsearch" {
  family                   = "zincsearch"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"  # Adjust as needed
  memory                   = "1024" # Adjust as needed
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([{
    name  = "zincsearch",
    image = "public.ecr.aws/zinclabs/zincsearch:latest",
  }])
}

// ECS task definition service for the Enron indexer
resource "aws_ecs_task_definition" "indexer" {
  family                   = "indexer"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"  # Adjust as needed
  memory                   = "1024" # Adjust as needed
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([{
    name  = "indexer",
    image = "your-indexer-image-url",
    // ... other container settings ...
  }])
}

// ECS task definition service for the Enron GO API
resource "aws_ecs_task_definition" "api_server" {
  family                   = "api-server"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"  # Adjust as needed
  memory                   = "1024" # Adjust as needed
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([{
    name  = "api-server",
    image = "your-api-server-image-url",
    // ... other container settings like port mappings ...
  }])
}

resource "aws_ecs_service" "zincsearch_service" {
  name            = "zincsearch-service"
  cluster         = aws_ecs_cluster.app_cluster.id
  task_definition = aws_ecs_task_definition.zincsearch.arn
  launch_type     = "FARGATE"
  // ... networking configuration ...
}

// Similar services for the indexer and API server
resource "aws_ecs_service" "indexer_service" {
  name            = "indexer-service"
  cluster         = aws_ecs_cluster.app_cluster.id
  task_definition = aws_ecs_task_definition.indexer.arn
  launch_type     = "FARGATE"
  // ... networking configuration ...
}

resource "aws_ecs_service" "api_service" {
  name            = "api-service"
  cluster         = aws_ecs_cluster.app_cluster.id
  task_definition = aws_ecs_task_definition.api_server.arn
  launch_type     = "FARGATE"
  // ... networking configuration ...
}
