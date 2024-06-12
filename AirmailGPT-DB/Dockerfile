# 베이스 이미지를 지정합니다.
FROM mysql:latest

# 환경 변수를 설정합니다. (예: root 사용자의 비밀번호)
ENV MYSQL_ROOT_PASSWORD=password
ENV MYSQL_USER: airmailgpt-for-rokaf
ENV MYSQL_PASSWORD: password

# 컨테이너 내부의 MySQL 데이터베이스를 로컬 머신에 마운트하기 위해 디렉토리를 생성합니다.
RUN mkdir -p /var/lib/mysql

# Docker 컨테이너가 시작될 때 자동으로 실행되는 SQL 스크립트를 복사합니다. (옵션)
COPY ./airmail-gpt-DB.sql /docker-entrypoint-initdb.d/

# Docker 컨테이너가 오픈할 포트를 지정합니다.
EXPOSE 3306
