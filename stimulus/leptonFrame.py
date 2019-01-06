import numpy as np
import random

class VospiPacket:
    def __init__(self,_id=0,segment=0,length=160,random=True,fixedPayload=0xff,telemetry=False,discard=False):
        self.random, self.fixed, self.segment = random,fixedPayload, segment
        self.discard = discard
        self.length=length
        assert(length==160 or length==240)
        self._id = _id

    @property
    def id(self):
        if(self.discard):
            return np.array( 0x0f00, dtype=np.uint16)
        elif(self._id == 20):
            return np.array( self._id+self.segment*4096, dtype=np.uint16)
        else:
            return np.array( self._id, dtype=np.uint16)

    @property
    def crc(self):
        return np.array( 0x5555 , dtype=np.uint16)

    @property
    def payload(self):
        if self.random:
            return np.random.randint(0,255,size=self.length).astype(np.uint8)
        else:
            return self.fixed*np.ones(self.length, dtype=np.uint8)

    @property
    def bytes(self):
        return b''.join([self.id.tobytes(), self.crc.tobytes(), self.payload.tobytes(),])

class VospiSegment:
    def __init__(self,_id=0,**kwargs):
        self.kwargs = kwargs
        assert( _id in range(1,5) )
        if 'telemetry' in kwargs.keys() and kwargs['telemetry'] == True:
            self.npackets = 61
        else:
            self.npackets = 60
        
        self._id = _id

    @property
    def bytes(self):
        lst = []
        for i in range(self.npackets):
            pkt = VospiPacket(i,segment=self._id,**self.kwargs)
            lst.append(pkt.bytes)
        return b''.join(lst)

class VospiFrame:
    SEGMENT_IDS = [1,2,3,4]
    def __init__(self,_id=0,**kwargs):
        self.kwargs = kwargs

    @property
    def bytes(self):
        lst = []
        for i in __class__.SEGMENT_IDS:
            seg = VospiSegment(_id=i,**self.kwargs)
            lst.append(seg.bytes)
        return b''.join(lst)

    def toFile(self,fname):
        with open(fname,'w') as f:
            for b in np.frombuffer(self.bytes,dtype=np.uint8):
                f.write(hex(b)+'\n')


test3 = VospiFrame(0,telemetry=False,discard=False,random=False,fixedPayload=0xAA)
test = test3.bytes
test3.toFile('frame.txt')
