# iOS App for Classifying Parallel Sewing

## Description
This application is designed to rate one aspect of practical sewing skills objectively; Sewing in parallel next to a given seam allowance. Our proposed implementation is directly applicable on sewn seams next to indicated lines mimicking said seam allowance. We laid focus on an automated skill evaluation which is straightforward to use. 

The implemented system uses color detection to determine lines and seams in order to match both components onto each other. Due to this, we are able to receive a pixel-accurate classification of the similarity between the seam and the printed line. The resulting scores relate to the accuracy of the replicated seams as well as to the consistency of the kept distance while sewing. Moreover, a low distance consistency close to 0 mm indicates a nearly perfect sewn seam in terms of parallelity. 

## Visuals
The app asks the user to upload a photo of their sewn result. It then immediately returns the output values as well as the computed matching of lines visually.

![Screenshot 2023-11-30 164219](https://github.com/juinmonospace/SewingSkillApp/assets/129877009/fd66fd16-c565-4464-aca0-58920bcf4358)


The collage below shows the input image taken of an exemplary perfect parallel seam next to an indicated seam allowance line. The digital output image produced by the app visually represents the yielded alignment of both lines. The screenshot shows the computed output values.

![Screenshot 2023-12-05 192858](https://github.com/juinmonospace/SewingSkillApp/assets/129877009/416970cf-f733-4ec3-af15-ac8eb37d8625)

An applied example with a real seam, sewn with red thread, and a green printed line accentuates the relevance of the distance consistency over the replication accuracy, as the latter produces a pixel-defined result that is not necessary in real-life scenarios. 

![Screenshot 2023-12-01 202151](https://github.com/juinmonospace/SewingSkillApp/assets/129877009/e4b1723d-bfc2-4643-b0d9-7a2081e5bd0b)

## Installation
To run this project, adding the prebuilt distribution of OpenCV is necessary. Download an iOS version from [opencv.org/releases](https://opencv.org/releases/) and include the unzipped file called opencv2.framework to the project. 

## Usage


## License

