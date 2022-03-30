import logging
import time
import os
import subprocess
from datetime import datetime
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

logging.basicConfig(level=logging.DEBUG, format="%(asctime)s - %(levelname)s - %(message)s")

def run_command(rc, cwd):
    try:
        output_bytes = subprocess.check_output(rc, shell=True, stderr=subprocess.STDOUT, cwd=cwd)
    except subprocess.CalledProcessError as e:
        output_bytes = e.output
    output_str = output_bytes.decode("utf-8")
    return output_str

class MyHandler(FileSystemEventHandler):
    def __init__(self, ext_watched):
        self.ext_watched = ext_watched
        self.last_modified = datetime.now()
    
    def is_time_to_run(self):
        now = datetime.now()
        if (now - self.last_modified).total_seconds() > 0.2:
            self.last_modified = now
            return True
        return False

    def on_modified(self, event):
        if event.is_directory:
            return
        path = os.path.normpath(event.src_path).split(os.sep)
        if len(path) < 1:
            return 
        filebase, fileext = os.path.splitext(path[-1])
        logging.info("File modified: %s, ext = %s", path, fileext)
        if fileext not in self.ext_watched:
            return
        if not self.is_time_to_run():
            logging.info("Too soon to run")
            return
        work_dir = os.path.join(*path[:-1])
        logging.info("Running gnuplot in %s", work_dir)
        rc = f"gnuplot plot.gp"
        print(run_command(rc, work_dir))


def main(figure_path, ext_watched):
    observer = Observer()
    observer.schedule(MyHandler(ext_watched), path=figure_path, recursive=True)
    observer.start()
    try:
        while True:
            time.sleep(3600)
    except KeyboardInterrupt:
        observer.stop()
    observer.join()

if __name__ == "__main__":
    main('./gnuplot', ['.gp', '.csv', '.txt'])
