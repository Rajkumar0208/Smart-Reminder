
SMART REMINDER
=================

A simple but smart reminder app to which you can current add a `Title` and a 	`Due Date`.
The title however can be typed by you or the app can suggest a few relevant tasks based on an image input.

**What does it do?**
----
* **Notifications**
		Sends you a notification when the due date has arrived.
* **Mark as completed**
		Mark a reminder as completed and feel relaxed
* **Mark as incomplete**
		Because we tend to mark incomplete things as completed to cheat ourselves
* **Delete**
		We've all been there when we make a reminder for something but we just don't want to be reminded about it
* **Overdue**
		You have not completed your task, we can't do anything but just turn it red, so it stands out and you feel guilty.

  
**Frameworks**
----
* **[Core Data](https://developer.apple.com/documentation/coredata)**
		All your reminders are obviously saved with the help of CoreData. A simple entity to just save the `title`, `dueDate` and `isCompleted`
		
* **[Core ML](https://developer.apple.com/documentation/coreml)**
		This app uses a `ImageClassifier.mlmodel`(created with [MLImageClassifierBuilder](https://developer.apple.com/documentation/createml/mlimageclassifierbuilder)), which is trained against a small dataset to detect the following:


Classifier | Objects
-------- | -----
Apparel | Shirt, T-shirt, Jeans
Grocery | Onions, potatoes, tomatoes
Vehicle | Cars
Book | Book and book covers


* **[Vision](https://developer.apple.com/documentation/vision)**
		Helps Core ML models for tasks like classification or object detection.


