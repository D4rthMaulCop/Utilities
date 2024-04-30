import qrcode
import sys

def CreateQRCode(url = "", saveLocation = ""):
     urlData = qrcode.make(url)
     img = qrcode.make(urlData)
     img.save(saveLocation)

if __name__ == "__main__":
     if len(sys.argv) < 3:
          print("[!] Check args...")
     elif len(sys.argv) > 3:
          print("[!] Check args...")
     else:
          CreateQRCode(sys.argv[1], sys.argv[2])
