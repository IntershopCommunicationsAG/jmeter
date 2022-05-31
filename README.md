# JMeter Docker Images provided by Intershop

This image build is inspired by https://github.com/hauptmedia/docker-jmeter and 
https://github.com/guitarrapc/docker-jmeter-gui.

## Usage 

run container
```
docker run -itd --rm -v ${TESTS_DIR}/:/tests -v ${TESTLOGS_DIR}/:/testlogs -v ${TESTDATA_DIR}/testdata -p 1099:1099 -p 5900:5900 -p 3390:3389 intershophub/jmeter:latest
```

docker-compose (see sample)
```
docker-compose up
```

environment variables

| variable      | default <br/> value           | description                          |
|---------------|-------------------------------|--------------------------------------|
| TEST_DIR      | `empty`                       | name of the test directory           |
| TEST_PLAN     | `empty`                       | name of the test plan                |
| REMOTE_HOSTS  | `empty`                       | list of remote hosts                 |
| SERVER_IP     | `empty`                       | IP of the server                     |
| HEAP          | "-Xmn968m -Xms3872m -Xmx3872m" | depends on the machine configuration |
| RESOLUTION    | "1366x768x24"                 | resolution for gui mode              |

login for gui mode

| login  | password |
|--------|----------|
| jmeter | jmeter   |

## License

Copyright 2014-2022 Intershop Communications.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.   