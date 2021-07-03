(in-package :cl-user)
(defpackage super-rentals.web
  (:use :cl
        :caveman2
        :super-rentals.config
        :super-rentals.view
        :super-rentals.db
        :datafly
        :sxql)
  (:export :*web*))
(in-package :super-rentals.web)

;; for @route annotation
(syntax:use-syntax :annot)

;;
;; Application

(defclass <web> (<app>) ())
(defvar *web* (make-instance '<web>))
(clear-routing-rules *web*)

(defvar *rentals* '(("grand-old-mansion" . (("id" . "grand-old-mansion")
					    ("title" . "Grand Old Mansion")
					    ("owner" . "John McCarthy")
					    ("city" . "San Francisco")
					    ("lat" . "37.7749")
					    ("lng" . "-122.4194")
					    ("category" . "Estate")
					    ("bedrooms" . "15")
					    ("image" . "https://upload.wikimedia.org/wikipedia/commons/c/cb/Crane_estate_(5).jpg")
					    ("description" . "This grand old mansion sits on over 100 acres of rolling hills and dense redwood forests.")))
		    ("urban-living" . (("id" . "urban-living")
				       ("title" . "Urban Living")
					    ("owner" . "Paul Graham")
					    ("city" . "Seattle")
					    ("lat" . "47.6062")
					    ("lng" . "-122.3321")
					    ("category" . "Condo")
					    ("bedrooms" . "1")
					    ("image" . "https://upload.wikimedia.org/wikipedia/commons/2/20/Seattle_-_Barnes_and_Bell_Buildings.jpg")
					    ("description" . "A commuters dream. This rental is within walking distance of 2 bus stops and the Metro.")))
		    ("downtown-charm" . (("id" . "downtown-charm")
					 ("title" . "Downtown Charm")
					    ("owner" . "Guy Steele")
					    ("city" . "Portland")
					    ("lat" . "45.5175")
					    ("lng" . "-122.6801")
					    ("category" . "Apartment")
					    ("bedrooms" . "3")
					    ("image" . "https://upload.wikimedia.org/wikipedia/commons/f/f7/Wheeldon_Apartment_Building_-_Portland_Oregon.jpg")
					    ("description" . "Convenience is at your doorstep with this charming downtown rental. Great restaurants and active night life are within a few feet.")))))

;;
;; Routing rules

(defroute "/" ()
  (format t "~a~%" *rentals*)
  (loop for r in *rentals*
	do(format t "~a~%" (cdr r)))
  (render #P"index.html" (list :rentals (mapcar #'(lambda (r) (cdr r)) *rentals*))))

(defroute "/about" ()
  (render #P"about.html"))

(defroute "/contact" ()
  (render #P"contact.html"))

(defroute "/rentals/:id" (&key id)
  (format t "~a~%" id)
  (format t "~a~%" (cdr (assoc id *rentals* :test #'string=)))
  (render #P"rentals.html" (list
			    :rental (cdr (assoc id *rentals* :test #'string=))))
			     )

(defroute "/search" ()
  (render #P"search.html"))
;;
;; Error pages

(defmethod on-exception ((app <web>) (code (eql 404)))
  (declare (ignore app))
  (merge-pathnames #P"_errors/404.html"
                   *template-directory*))
