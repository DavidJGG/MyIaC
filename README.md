# TerraformProject
Proyecto Terrafom

![nClouds Connect Project 1](https://github.com/DavidJGG/TerraformProject/assets/60149403/34a9c366-b1a9-4cfb-b682-b42db6debeb9)

## Reminder

- Put credentials in the aws credentials file located in: 
	{path to personal folder}/.aws/credential
- Download the project and open a terminal inside
- **A Hosted Zone must exist in Route 53**
- Open the ./variables.tf and edit `profile_names` and `aws_region`. Put your information
- Modify `modules\launchtemplate\main.tf` and put a custom ssh public key in `resource "aws_key_pair" "myKey"`
- Create a two workspaces with terraform and execute
	  terraform workspace select proy
	  terraform workspace select virginia
	this commans, will create two work spaces, one to deploy in oregon, and other to deploy in virginia.
	
- Select one workespace and run (select only one):
	for workspace proy: 
	    terraform apply -var-file .\variables\proy.tfvalues
	for workspace virginia:
	    terraform apply -var-file .\variables\virginia.tfvalues
	this commands will deploy the infrastructure in a diferent region.



