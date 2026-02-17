exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
apt-get install -y git docker-compose-plugin

docker volume create portainer_data
docker run -d -p 8000:8000 -p 9443:9443 --name portainer \
  --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-ce:latest

mkdir -p /opt/myapp
cd /opt/myapp

git clone https://github.com/levatax/admin-dashboard.git .

cat << 'EOF' > docker-compose.yml
services:
  nextjs:
    build: .
    ports:
      - "80:3000"
    environment:
      - MONGODB_URI=mongodb://mongodb:27017/appdb 
      - AUTH_SECRET=myauthsecret123
    depends_on:
      - mongodb
    restart: always

  mongodb:
    image: mongo:latest
    ports:
      - "27017:27017"
    volumes:
      - mongo_data:/data/db
    restart: always

volumes:
  mongo_data:
EOF

docker compose up -d --build

echo "Waiting for Next.js and MongoDB to start..."

until [ "$(curl -s -o /dev/null -w "%{http_code}" http://localhost/api/seed)" = "200" ]; do
  echo "App not ready yet, waiting 5 seconds..."
  sleep 5
done

echo "Database seeded successfully! Admin user is ready."