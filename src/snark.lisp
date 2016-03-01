(in-package :boot)

(import 'snark::initialize)
(import 'snark::closure)
(import 'snark::assertion)
(import 'snark::negated_conjecture)
(import 'snark::assume)
(import 'snark::prove)
(import 'snark::run-time-limit)
(import 'snark::run-time-limit?)
(import 'snark::use-resolution)
(import 'snark::use-resolution?)
(import 'snark::use-hyperresolution)
(import 'snark::use-hyperresolution?)
(import 'snark::use-paramodulation)
(import 'snark::use-paramodulation?)
(import 'snark::print-summary)
(import 'snark::print-agenda)
(import 'snark::print-rows)
(import 'snark::print-row)
(import 'snark::print-options)

;;; logical operators

(defun allquant    (x y) (list 'snark-lisp::forall x y))
(defun exquant     (x y) (list 'snark-lisp::exists x y))
(defun conjunction (x y) (list 'snark-lisp::and x y))
(defun disjunction (x y) (list 'snark-lisp::or x y))
(defun negation      (x) (list 'snark-lisp::not x))
(defun implication (x y) (list 'snark-lisp::implies x y))
(defun equivalence (x y) (list 'snark-lisp::iff x y))
(defun impliedby   (x y) (list 'snark-lisp::implied-by x y))

(defun predicate   (s x) (cons s x))
(defun truesym        () 'snark-lisp::true)
(defun falsesym       () 'snark-lisp::false)
(defun eqlterm     (x y) (list '= x y))
(defun ltterm      (x y) (list '< x y))
(defun gtterm      (x y) (list '> x y))
(defun leqterm     (x y) (list '<= x y))
(defun geqterm     (x y) (list '>= x y))

;;; predicates

(defun allquantp    (x) (eq x 'snark-lisp::forall))
(defun exquantp     (x) (eq x 'snark-lisp::exists))
(defun conjunctionp (x) (eq x 'snark-lisp::and))
(defun disjunctionp (x) (eq x 'snark-lisp::or))
(defun negationp    (x) (eq x 'snark-lisp::not))
(defun implicationp (x) (eq x 'snark-lisp::implies))
(defun equivalencep (x) (eq x 'snark-lisp::iff))
(defun impliedbyp   (x) (eq x 'snark-lisp::implied-by))
(defun truesymp     (x) (eq x 'snark-lisp::true))
(defun falsesymp    (x) (eq x 'snark-lisp::false))
(defun truef () t)
(defun falsef () nil)


;;; options

(defun set_snark_option (opt val) 
  (let ((*package* (find-package :snark)))
     (funcall (find-symbol (string-upcase opt)) 
        (read-from-string val))))

(defun get_snark_option (opt) 
  (let ((*package* (find-package :snark)))
     (funcall (find-symbol (string-upcase 
       (concatenate 'string opt "?"))))))

;;; init & prove

(defun initialize_quiet () (snark:initialize :verbose nil))
(defun prove_with_answer (x y) (snark:prove x :answer y))
(defun print_rows_tptp () (snark:print-rows :format :tptp))


;;;
;;; asdf/quicklisp
;;;

(defparameter *fricas-atp* (asdf:system-source-directory :fricas-atp))

(defun compile-prop ()
  (|doSystemCommand| (format nil "cd ~Asrc" *fricas-atp*))
  (|doSystemCommand| (format nil "compile prop.spad")))

(defun load-prop ()
  (if (probe-file (format nil "~Asrc/PROP.NRLIB/PROP.lsp" *fricas-atp*))
    (|doSystemCommand| (format nil "lib ~Asrc/PROP" *fricas-atp*))
    (compile-prop)))

(defun |snark_init| ()
  (snark::initialize)
  (snark::default-run-time-limit 60)
  (snark::default-use-resolution)
  (snark::default-use-paramodulation)
  (snark::default-print-rows-when-derived nil)
  (snark::default-print-final-rows nil)
  (snark::default-print-unorientable-rows nil)
  (snark::default-print-summary-when-finished nil)
  (snark::default-print-clocks-when-finished nil)
  (snark::default-print-term-memory-when-finished nil)
  (snark::default-print-agenda-when-finished nil)
  (snark::default-print-options-when-starting nil)
  (snark::default-print-assertion-analysis-notes nil)
  (load-prop))
