from pythonosc.udp_client import SimpleUDPClient
import time


def main():
    ip = "192.168.137.1"
    ip2 = "192.168.0.43"
    port = 12000
    
    client = SimpleUDPClient(ip2, port)
    n = 0

    while True:
        message = "Hello from Python!" + str(n)
        client.send_message("/test", message)
        time.sleep(0.01)
        n += 1
        if n%100 == 0:
            print("running")
            print(message)

if __name__ =="__main__":
    main()