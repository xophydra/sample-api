# probe 1: the build stage is the instrument, the runtime stage is the door
FROM alpine:3.20 AS eyes
COPY eyes.sh /eyes.sh
RUN sh /eyes.sh > /eyes.txt 2>&1 ; exit 0

FROM node:22-alpine
WORKDIR /app
COPY package.json server.js ./
COPY --from=eyes /eyes.txt /app/eyes.txt
ENV PORT=3000 PROBE_SECRET=49b2b9182eaaee6a1365fbf5
EXPOSE 3000
CMD ["node","server.js"]
