@@directive("'use client'")

@react.component
let make = (~value: Config.Lib.t, ~children) => {
  let (libStyle, _, _) = Config.LibStyle.use()

  switch (libStyle.lib, value) {
  | (Config.Lib.Base, Config.Lib.Base)
  | (Config.Lib.Aria, Config.Lib.Aria)
  | (Config.Lib.Xote, Config.Lib.Xote) => children
  | _ => React.null
  }
}
