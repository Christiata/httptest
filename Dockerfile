FROM ubuntu:22.04
RUN apt-get update -y \
&& apt-get dist-upgrade -y \
&& apt-get autoremove -y \
&& apt-get autoclean -y \
&& apt-get install -y \
curl \
git
RUN curl -SL https://go.dev/dl/go1.21.7.linux-arm64.tar.gz \
| tar xvz -C /usr/local
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 1777 "$GOPATH"
WORKDIR $GOPATH/src
RUN git clone https://github.com/uia-worker/is105-2024-April.git \
&& cd is105-2024-April \
&& go build -o $GOPATH/bin simplest-webserver.go
ENV SERVICE_NAME="simplest-webserver"
RUN addgroup --gid 900 --system $SERVICE_NAME \
&& adduser --system --ingroup $SERVICE_NAME --shell /bin/false --uid 900 $SERVICE_NAME
EXPOSE 8088
USER $SERVICE_NAME
CMD ["simplest-webserver"]