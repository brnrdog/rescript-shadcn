/* The sonner-flavoured entry point: same store as `Toast`, so `Sonner.toast`
   and `Toast.add` push to one queue and one viewport renders them. */
module Toaster = Toast.Toaster

let toast = Toast.add
let dismiss = Toast.dismiss
