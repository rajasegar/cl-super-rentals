(defsystem "super-rentals-test"
  :defsystem-depends-on ("prove-asdf")
  :author "Rajasegar Chandran"
  :license ""
  :depends-on ("super-rentals"
               "prove")
  :components ((:module "tests"
                :components
                ((:test-file "super-rentals"))))
  :description "Test system for super-rentals"
  :perform (test-op (op c) (symbol-call :prove-asdf :run-test-system c)))
