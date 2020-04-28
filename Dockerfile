FROM ruby:2.6.5

RUN apt-get update -qq && \
apt-get install -y build-essential \
libpq-dev \
nodejs
    
RUN mkdir /app
ENV APP_ROOT /app
WORKDIR $APP_ROOT
# このファイル（Dockerfile）と同じ階層にあるGemfile等をコンテナにコピー
COPY ./Gemfile $APP_ROOT/Gemfile
COPY ./Gemfile.lock $APP_ROOT/Gemfile.lock
# コンテナのGemfileを参考にGemをインストール
RUN bundle install
# このファイルが含まれているディレクトリをコンテナのルートディレクトリにコピー
COPY . $APP_ROOT

CMD ["rails", "server", "-b", "0.0.0.0"]
