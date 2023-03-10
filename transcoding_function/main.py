import functions_framework
import os
from google.cloud.video import transcoder_v1
from google.cloud.video.transcoder_v1.services.transcoder_service import (
    TranscoderServiceClient,
)

@functions_framework.cloud_event
def handle_gcs_event(cloud_event):
    data = cloud_event.data

    bucket = data["bucket"]

    name = data["name"]
    project_id = os.environ.get("PROJECT_ID")
    region = os.environ.get("REGION")

    input_uri = f"gs://{bucket}/{name}"
    output_uri = f"gs://hls-streaming-gcp-processed-files-{project_id}/{name}/"
    preset = "preset/web-hd"

    client = TranscoderServiceClient()

    parent = f"projects/{project_id}/locations/{region}"
    job = transcoder_v1.types.Job()
    job.input_uri = input_uri
    job.output_uri = output_uri
    job.template_id = preset

    response = client.create_job(parent=parent, job=job)
    
    print(response)

