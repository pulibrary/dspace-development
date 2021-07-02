# DataSpace

DataSpace is the DSpace implementation for Princeton University, currently
serving as the research data repository and platform for publishing graduate
dissertations, senior theses, research datasets from PU and PPPL stakeholders,
and a selection of monographs and periodicals maintained by the Princeton
University Library.

## Graduate Dissertation Collections

The process of importing new dissertations is tracked in the [`etd_transformer`](https://github.com/pulibrary/etd_transformer)
repository. And [here is a link to the process's documentation.](https://pulibrary.github.io/etd_transformer/process-dissertations.html)

## Senior Thesis Import

The annual process of importing senior theses is tracked in the [`etd_transformer`](https://github.com/pulibrary/etd_transformer)
repository. And [here is a link to the process's documentation.](https://pulibrary.github.io/etd_transformer/process-theses.html)

## Globus

[Globus](https://www.globus.org/) is a platform that allows users to upload and
download large datasets easily. When working with researchers, PRDS will link to
Globus through Dataspace's metadata instead of storing the data directly in Dataspace. 

[An example Dataspace dataset with data in Globus.](https://dataspace.princeton.edu/handle/88435/dsp01nz8062179)
[ITIMS Google Drive containing Globus documentation.](https://drive.google.com/drive/folders/1W3PM757IW6dMqD_kZizQVdNftvm1Ct6V?usp=sharing)

## Mailhog

[Mailhog](https://github.com/mailhog) is set up on the development and staging servers and is used to test Dataspace's email system. Instead of emails being sent to the user, it's sent to the Mailhog interface, which is available on your local machine if you tunnel to it:

```bash
ssh -L 8025:localhost:8025 -J pulsys@$JUMP_IP pulsys@$DATASPACE_IP
```

Open localhost:8025 in your browser and you should be able to see the Mailhog interface.
