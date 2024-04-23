# tl

This shell script provides a simple command-line utility to log and convert time data between different units such as seconds, minutes, hours, days, and weeks. It is designed to help track time spent on tasks by logging them and allowing for conversions between different time units for ease of understanding and reporting.

## Features

* Log time data with a custom label.
* Convert time into seconds, minutes, hours, days, or weeks.
* Reset the time log.
* Output the accumulated time data in a human-readable format.

## Requirements

- Bash
- `bc` (for basic calculations)

## Installation

1. Clone this repository or download the script directly.
2. Ensure the script is executable:
   ```sh
   chmod +x tl
   ```

## Usage

Run the script with the following syntax:

```sh
./tl [options] [label]
```

Options:
* -s: Silent mode. No output is printed.
* -r: Reset the time log by removing the data file.
* -S: Output time in seconds.
* -m: Output time in minutes.
* -h: Output time in hours.
* -d: Output time in days.
* -w: Output time in weeks.
* -H: Output time in a human-readable format (default).

Labels are used to log time for different tasks. Each label should consist of alphanumeric characters only. Non-alphanumeric labels will result in an error.

The script stores its data in a file named .tl by default. You can change the data file by setting the TLFILE environment variable to your preferred file path.
