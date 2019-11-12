class Reading {
  final int Id;
  final String Guid;
  final String SourceGuid;
  final String IPs;
  final int Temp;
  final String MeasurementTimestamp;
  final String CreatedAt;
  final String Name;
  final String Status;

  Reading._({
    this.Id,
    this.Guid,
    this.SourceGuid,
    this.IPs,
    this.Temp,
    this.MeasurementTimestamp,
    this.CreatedAt,
    this.Name,
    this.Status,
  });

  factory Reading.fromJson(Map<String, dynamic> json) {
    return new Reading._(
      Id: json['Id'],
      Guid: json['Guid'],
      SourceGuid: json['SourceGuid'],
      IPs: json['IPs'],
      Temp: json['Temp'],
      MeasurementTimestamp: json['MeasurementTimestamp'],
      CreatedAt: json['CreatedAt'],
      Name: json['Name'],
      Status: json['Status'],
    );
  }
}

