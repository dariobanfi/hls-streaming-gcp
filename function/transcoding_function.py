import functions_framework
from google.cloud.video import transcoder_v1
from google.cloud.video.transcoder_v1.services.transcoder_service import (
    TranscoderServiceClient,
)

def create_job_from_preset(project_id, location, input_uri, output_uri, preset):
    """Creates a job based on a job preset.

    Args:
        project_id: The GCP project ID.
        location: The location to start the job in.
        input_uri: Uri of the video in the Cloud Storage bucket.
        output_uri: Uri of the video output folder in the Cloud Storage bucket.
        preset: The preset template (for example, 'preset/web-hd')."""

    client = TranscoderServiceClient()

    parent = f"projects/{project_id}/locations/{location}"
    job = transcoder_v1.types.Job()
    job.input_uri = input_uri
    job.output_uri = output_uri
    job.template_id = preset

    response = client.create_job(parent=parent, job=job)
    print(f"Job: {response.name}")
    return response

# Triggered by a change in a storage bucket
@functions_framework.cloud_event
def handle_gcs_event(cloud_event):
    data = cloud_event.data

    event_id = cloud_event["id"]
    event_type = cloud_event["type"]

    file_id = data["id"]
    self_link = data["selfLink"]
    bucket = data["bucket"]
    name = data["name"]
    metageneration = data["metageneration"]
    timeCreated = data["timeCreated"]
    updated = data["updated"]

    print(cloud_event)

    result = create_job_from_preset("hls-streaming-gcp", "europe-west1", f"gs://{bucket}/{name}" , "gs://hls-streaming-gcp-processed-files/", "preset/web-hd")

    print(result)
