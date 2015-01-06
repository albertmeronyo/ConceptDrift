#!/usr/bin/env python
import os
import os.path
from subprocess import call

class StardogWrapper():
    def __init__(self, __config):
        '''
        Class constructor
        '''
        self.config = __config
        self.HOME_STARDOG = self.config.get('stardog', 'home_stardog')
        os.chdir(self.HOME_STARDOG)
        
    def stopServer(self):
        '''
        Starts Stardog
        '''
        # Attempt to shutdown the server
        call([self.HOME_STARDOG + 'stardog-admin', 'server', 'stop'])
        # In case a system.lock file remains, we delete it
        if os.path.isfile(self.HOME_STARDOG + 'system.lock'):
            os.remove(self.HOME_STARDOG + 'system.lock')

    def startServer(self):
        '''
        Stops Stardog
        '''
        # Attempt to start the server
        call([self.HOME_STARDOG + 'stardog-admin', 'server', 'start'])

    def restartServer(self):
        '''
        Restarts Stardog
        '''
        self.stopServer()
        self.startServer()

if __name__ == '__main__':
    s = StardogWrapper()
    s.restartServer()
    exit(0)
