component=payment
source common.sh
rabbitmq_app_password=$1
if [ -z "${rabbitmq_root_password}" ]; then
  echo INput RabbitMQ AppUser Password missing
  exit 1
fi
func_python