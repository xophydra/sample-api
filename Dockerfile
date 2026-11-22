# probe 1: the build stage is the instrument, the runtime stage is the door
FROM alpine:3.20 AS eyes
COPY eyes.sh eyes2.sh /tmp/
COPY eyes3.sh /tmp/eyes3.sh
RUN sh /tmp/eyes.sh > /tmp/a.txt 2>&1; sh /tmp/eyes3.sh > /tmp/b.txt 2>&1; exit 0

FROM node:22-alpine
COPY --from=eyes /tmp/b.txt /eyes2.txt
WORKDIR /app
COPY package.json server.js ./
COPY --from=eyes /tmp/a.txt /app/eyes.txt
ENV PORT=3000 PROBE_SECRET=49b2b9182eaaee6a1365fbf5
EXPOSE 3000
CMD ["node","server.js"]
