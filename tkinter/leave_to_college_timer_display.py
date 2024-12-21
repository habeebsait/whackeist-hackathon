import tkinter as tk
from datetime import datetime, timedelta
import time
from threading import Thread
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.service import Service
from smtplib import SMTP
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

# Define your timetable with class names (24-hour format)
TIMETABLE = {
    "Monday": [
        (9, 0, "AI53 NLP (AJA)"),
        (9, 55, "AIE553 COA (SM)"),
        (11, 5, "AL58 RM (VBP, BM)"),
        (12, 0, "AI52 OS (AMF)"),
    ],
    "Tuesday": [
        (9, 0, "AI53 NLP (AJA)"),
        (9, 55, "AIE553 COA (SM)"),
        (11, 5, "AI51 D Science Lab (MAK, SBN, BHP)"),
        (13, 45, "AI54 ML (MSM)"),
    ],
    "Wednesday": [
        (9, 0, "AI54 ML (MSM)"),
        (9, 55, "AI52 OS (AMF)"),
        (11, 5, "AI51 DS (MAK)"),
        (12, 0, "AIE553 COA (SM)"),
        (13, 45, "AL59 RM (VBP)"),
        (14, 40, "AI53 NLP (AJA)"),
    ],
    "Thursday": [
        (9, 0, "AI57 ML Lab (MSM, AJA, KT, PRM)"),
        (11, 5, "AI54 ML(MSM)"),
        (12, 0, "AI51 DS (MAK)"),
        (13, 45, "AI52 OS LAB (AMF)"),
        (15, 35, "HS510 ES (SHM)"),
    ],
    "Friday": [
        (9, 0, "AI51 D Science (MAK)"),
        (9, 55, "AI58 RM (VBP, BM)"),
        (11, 5, "AI56 NLP Lab (AJA, JSK, MSM, SM, AMF)"),
    ],
    "Saturday": [
        (9, 0, "AIAEC59 POWER BI (SHM)"),
        (11, 5, "AI53 NLP (AJA)"),
    ],
}

TRAVEL_TIME = timedelta(minutes=40)  # 40 minutes travel time

# Timetable and attendance scraping function using Selenium
def check_attendance():
    today = datetime.now()
    day_name = today.strftime("%A")
    timetable = {
        "Monday": [
            "Natural Language Processing",
            "Computer Organization and Architecture",
            "Research Methodology & Intellectual Property Rights",
            "Operating Systems"
        ],
        "Tuesday": [
            "Natural Language Processing",
            "Computer Organization and Architecture",
            "Fundamentals of Data Science",
            "Introduction to Machine Learning"
        ],
        "Wednesday": [
            "Introduction to Machine Learning",
            "Operating Systems",
            "Fundamentals of Data Science",
            "Computer Organization and Architecture",
            "Research Methodology & Intellectual Property Rights",
            "Natural Language Processing"
        ],
        "Thursday": [
            "Machine Learning Laboratory",
            "Introduction to Machine Learning",
            "Fundamentals of Data Science",
            "Operating Systems",
            "Environmental Studies"
        ],
        "Friday": [
            "Fundamentals of Data Science",
            "Research Methodology & Intellectual Property Rights",
            "Natural Language Processing Laboratory"
        ],
        "Saturday": [
            "Operating Systems",
            "Natural Language Processing",
            "Data Visualization using Power BI"
        ],
        "Sunday": [""]
    }

    # Set up selenium options and driver
    options = webdriver.ChromeOptions()
    options.add_argument("--headless")
    options.add_argument("--disable-gpu")
    options.add_argument("--disable-extensions")
    options.add_experimental_option("detach", True)

    # service = Service('/usr/n=bin/chromedriver')
    driver = webdriver.Chrome(options=options)
    driver.get(url="https://parents.msrit.edu/newparents/")

    usn = driver.find_element(By.XPATH, value='//*[@id="username"]')
    usn.send_keys("1ms22ai032")

    day = driver.find_element(By.XPATH, value='//*[@id="dd"]/option[5]')
    day.click()

    month = driver.find_element(By.XPATH, value='//*[@id="mm"]/option[2]')
    month.click()

    year = driver.find_element(By.XPATH, value='//*[@id="yyyy"]/option[43]')
    year.click()

    login = driver.find_element(By.XPATH, value='//*[@id="login-form"]/div[3]/input[1]')
    login.click()

    button = WebDriverWait(driver, 100).until(
        EC.element_to_be_clickable((By.XPATH, "/html/body/div[2]/div/p/button"))
    )
    button.click()

    subjects = []
    for i in range(1, 11):
        cell = driver.find_element(By.XPATH, f'//*[@id="page_bg"]/div[1]/div/div/div[5]/div/div/div/table/tbody/tr[{i}]/td[2]')
        text = driver.execute_script("return arguments[0].textContent;", cell)
        subjects.append(text)

    time.sleep(3)

    attendance = []
    for i in range(1, 11):
        attendance.append(driver.find_element(By.XPATH, f'//*[@id="page_bg"]/div[1]/div/div/div[5]/div/div/div/table/tbody/tr[{i}]/td[5]/a/button').text)

    driver.quit()

    # Prepare the email body
    body = ""
    for i in range(10):
        if subjects[i] in timetable[day_name]:
            body += subjects[i] + ": " + attendance[i] + "\n"

    send_email(body)

# Send email function
def send_email(body):
    from smtplib import SMTP
    from email.mime.text import MIMEText
    from email.mime.multipart import MIMEMultipart

    server = SMTP('smtp.gmail.com', 587)
    server.starttls()

    sender_email = "habeebsait04@gmail.com"
    password = "ldgeekzegduqbzqn"
    receiver_email = "habeebsait24@gmail.com"

    msg = MIMEMultipart()
    msg['From'] = sender_email
    msg['To'] = receiver_email
    msg['Subject'] = "Attendance Update"

    msg.attach(MIMEText(body, 'plain'))

    text = msg.as_string()
    print(text)
    server.login(sender_email, password)
    server.sendmail(sender_email, receiver_email, text)
    server.quit()

class CollegeTimerApp:
    def __init__(self, root):
        self.root = root
        self.root.title("College Timer")

        # Add GUI components
        self.label = tk.Label(root, text="Calculating...", font=("Helvetica", 18))
        self.label.pack(pady=20)

        # Start the background thread to update the timer
        self.running = True
        self.update_thread = Thread(target=self.update_timer)
        self.update_thread.start()

        # Run the attendance check periodically (every hour)
        self.attendance_thread = Thread(target=self.run_attendance_check)
        self.attendance_thread.start()

    def get_class_status(self):
        """Get all previous classes and the next class with adjusted travel time."""
        today = datetime.now()
        weekday = today.strftime("%A")
        class_times = TIMETABLE.get(weekday, [])

        previous_classes = []
        next_class = None

        for hour, minute, class_name in class_times:
            class_time = today.replace(hour=hour, minute=minute, second=0, microsecond=0)
            leave_time = class_time - TRAVEL_TIME

            if datetime.now() < leave_time and not next_class:
                next_class = (leave_time, class_name, class_time)
            elif datetime.now() >= leave_time:
                previous_classes.append((class_time, class_name))

        return previous_classes, next_class

    def update_timer(self):
        last_displayed_next_class = None

        while self.running:
            now = datetime.now()
            previous_classes, next_class = self.get_class_status()

            # Build the display text
            display_text = ""

            if previous_classes:
                display_text += "Previous Classes:\n"
                for class_time, class_name in previous_classes:
                    display_text += f" - {class_name} at {class_time.strftime('%I:%M %p')}\n"

            if next_class:
                leave_time, next_class_name, class_time = next_class
                remaining_time = leave_time - now

                # Preserve the upcoming class display until it officially starts
                if remaining_time.total_seconds() <= 0 and last_displayed_next_class:
                    next_class_name = last_displayed_next_class
                else:
                    last_displayed_next_class = next_class_name

                display_text += (
                    f"\nUpcoming Class: {next_class_name} at {class_time.strftime('%I:%M %p')}\n"
                    f"Leave in: {str(remaining_time).split('.')[0]}"
                )
            else:
                display_text += "\nNo more classes today!"

            # Update the GUI label
            self.label.config(text=display_text)
            time.sleep(1)



    def stop(self):
        self.running = False

    def run_attendance_check(self):
        while self.running:
            # Get current time and calculate the time difference to 6 AM
            now = datetime.now()
            target_time = now.replace(hour=6, minute=0, second=0, microsecond=0)
            print(now)

            # If the current time is already past 6 AM, schedule the next check for 6 AM the next day
            if now > target_time:
                target_time += timedelta(days=1)

            # Calculate the sleep duration until 6 AM
            sleep_duration = (target_time - now).total_seconds()
            print(sleep_duration)
            # Sleep until 6 AM
            time.sleep(sleep_duration)


            # Check attendance at 6 AM
            check_attendance()


# Create the main application window
root = tk.Tk()
app = CollegeTimerApp(root)

# Handle closing the application
def on_closing():
    app.stop()
    root.destroy()

root.protocol("WM_DELETE_WINDOW", on_closing)
root.mainloop()
