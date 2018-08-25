# Be sure to restart your server when you modify this file.

# match this in your nginx config for bypassing the file cache
Blockchain::Application.config.session_store :cookie_store,
                                             key: '0xblockchain_session',
                                             expire_after: 1.month
