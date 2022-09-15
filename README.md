# CrowdTesting Test Task
This is a Robot Framework project for testing Reddit API according to the CrowdTesting test task.

## Installation and run

Make sure that Python3 and pip are installed on your computer.

To install all dependencies needed for test running enter this command:

```shell
pip install -r requirements.txt
```

To run the tests enter this command:

```shell
robot -d logs test_reddit_api.robot
```

After the tests completion you can see log files in the `logs/` directory.
