######################################################################################################################
# SNS
#################################################################################################################

resource "aws_sns_topic" "os_ingestion_events" {
    name = "${var.name_prefix}-${var.env}-${var.region}-${var.product_name}-od-ingestion-event-sns-topic.fifo"
    display_name = name = "${var.name_prefix}-${var.env}-${var.region}-${var.product_name}-od-ingestion-event-topic"
    fifo_topic = true
    content_based_deduplication = true
    kms_master_key_id = var.default_kms_key_arn
    sqs_success_feedback_role_arn = var.os_ingestion_events_sqs_feedback_role_arn
    sqs_failure_feedback_role_arn = var.os_ingestion_events_sqs_feedback_role_arn
    tags = merge(tomap({"access-env" = var.env}), var.tags)
  
}