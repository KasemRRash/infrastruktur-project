#!/bin/bash

emailLogin="$1"
email_subject="$2"
email_body="$3"
echo "To: $emailLogin" >> sent_emails.txt
echo "Subject: $email_subject" >> sent_emails.txt
echo -e "$email_body\n" >> sent_emails.txt
echo "E-Mail gesendet an $emailLogin mit Betreff $email_subject"

