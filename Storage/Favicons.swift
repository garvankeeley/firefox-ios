/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import Shared
import UIKit

/* The base favicons protocol */
public protocol Favicons {
    func clearAllFavicons() -> Success

    /**
     * Returns a tuple of history URL mapped to a list of matching favicons.
     */
    func getFaviconsForHistoryURLs(urls: [String]) -> Deferred<Maybe<Cursor<(String, Favicon)?>>>

    /**
     * Returns the ID of the added favicon.
     */
    func addFavicon(icon: Favicon) -> Deferred<Maybe<Int>>

    /**
     * Returns the ID of the added favicon.
     */
    func addFavicon(icon: Favicon, forSite site: Site) -> Deferred<Maybe<Int>>
}
