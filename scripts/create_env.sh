echo "Fetching environment variables from AWS SSM..."

APP_NAME=$(aws ssm get-parameter --name "/APP_NAME" --with-decryption --query "Parameter.Value" --output text)
DEBUG=$(aws ssm get-parameter --name "/DEBUG" --with-decryption --query "Parameter.Value" --output text)
PORT=$(aws ssm get-parameter --name "/PORT" --with-decryption --query "Parameter.Value" --output text)

cd /home/ec2-user/your-app-folder || exit

echo "APP_NAME=$APP_NAME" > .env
echo "DEBUG=$DEBUG" >> .env
echo "PORT=$PORT" >> .env

echo ".env file created successfully."