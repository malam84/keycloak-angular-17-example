FROM node:20.17.0-alpine as build

# Set the working directory
WORKDIR /usr/local/app

# RUN npm cache clean --force

# Add the source code to app
COPY ./ /usr/local/app/
RUN ls  /usr/local/app
# Install all the dependencies
RUN npm install

# Generate the build of the application
RUN npm run build

RUN ls  /usr/local/app
# Stage 2: Serve app with nginx server
RUN ls  /usr/local/app/dist/keycloak-angular-example/browser
# Use official nginx image as the base image
FROM nginx:latest
# Copy the build output to replace the default nginx contents.
RUN echo $(ls -1 /usr/local/app)
COPY --from=build /usr/local/app/dist/keycloak-angular-example/browser /usr/share/nginx/html
COPY ./nginx.conf  /etc/nginx/conf.d/default.conf
RUN ls  /usr/share/nginx/html
# Expose port 80
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]