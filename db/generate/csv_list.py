import csv

def read(input_file, header_row=False, delimiter=';', quotechar='"'):
    data = []
    with open(input_file) as csv_file:
        reader = csv.reader(csv_file, delimiter=delimiter, quotechar=quotechar)
        for row in reader:
            data.append(row)
    if header_row:
        del data[0]
    return data

def write(input_list, output_file, delimiter=';', quotechar='"'):
    with open(output_file, 'w', newline='\n') as csv_file:
        writer = csv.writer(csv_file, delimiter=delimiter,
                            quotechar=quotechar, quoting=csv.QUOTE_MINIMAL)
        for row in input_list:
            writer.writerow(row)
