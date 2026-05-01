#!/usr/bin/env python3
from fpdf import FPDF 
input_file = "/var/log/snort/alert"
output_file = "/home/attacker/report.pdf"

pdf = FPDF()
pdf.add_page()
pdf.set_font("Arial", size=10)

file = open("/var/log/snort/alert", "r")

for line in file:
	pdf.cell(0, 8, txt=line, ln=True)

file.close()

pdf.output("/home/attacker/report.pdf")
print("PDF created!")


