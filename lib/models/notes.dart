class Notes {
    int id;
    String title;
    String description;
    String label;
    String type;
    String status;
    String dueDate;
    String createDate;

    Notes({
        this.id,
        this.title,
        this.description,
        this.label,
        this.type,
        this.status,
        this.dueDate,
        this.createDate,
    });

    factory Notes.fromJson(Map < String, dynamic > json) {
        return Notes(
            id: json['id'],
            title: json['title'],
            description: json['description'],
            label: json['label'],
            type: json['type'],
            status: json['status'],
            dueDate: json['due_date'],
            createDate: json['created_at']
        );
    }
}

class CountNotes {
    int complete;
    int onprogress;
    int overdate;

    CountNotes({
      this.complete,
      this.onprogress,
      this.overdate,
    });

    factory CountNotes.fromJson(Map < String, dynamic > json) {
        return CountNotes(
          complete: json['complete'],
          onprogress: json['onprogress'],
          overdate: json['overdate'],
        );
    }
}