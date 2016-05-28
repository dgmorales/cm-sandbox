#!/usr/bin/env python
import pika
import time
import getpass
import random
from optparse import OptionParser

usage = """Usage: %prog [options] HOST [MESSAGE]

Test RabbitMQ publishing and consuming. By default acts as publisher. Pass -w
for worker mode.

If you do not specify the password (-p, --password), it will ask you for it in
the terminal.

If MESSAGE contain n dots (.) the worker will sleep for n seconds when it
consumes the message. This is simplistic simulation of task "heaviness". When
generating the messages you can use -r and other params to generate a random
number of dots in the messages sent.

MESSAGE, -n and -r are ignored in worker mode.

Use %prog -h for options help."""

def publish(channel, options, message):
    for i in xrange(options.count):

        if options.random:
            message_dots = ('.' * random.randint(options.random_min, options.random_max)) + ' '
        else:
            message_dots = ''

        if message.find('%s') >= 0:
            real_message = message % i
        elif options.count == 1:
            real_message = message
        else:
            real_message = ' '.join((message, str(i)))

        real_message = message_dots + real_message
        channel.basic_publish(exchange='',
                            routing_key=options.queue,
                            body=real_message,
                            properties=pika.BasicProperties(
                                delivery_mode = 2, # make message persistent
                            ))
        print " [x] Sent %r" % (real_message)

def consume(channel, options):
    print ' [*] Waiting for messages. To exit press CTRL+C'

    def callback(ch, method, properties, body):
        print " [x] Received %r" % (body,)
        time.sleep( body.count('.') )
        print " [x] Done"
        ch.basic_ack(delivery_tag = method.delivery_tag)

    channel.basic_qos(prefetch_count=1)
    channel.basic_consume(callback,
                        queue=options.queue)

    try:
        channel.start_consuming()
    except KeyboardInterrupt:
        print ' [*] Interrupted. Exiting...'

if __name__ == "__main__":
    parser = OptionParser(usage=usage)
    parser.add_option("-u", "--user", dest="user", default='admin',
                    help="RabbitMQ username.", metavar="USER")

    parser.add_option("-p", "--password", dest="password",
                    help="RabbitMQ password.", metavar="PASSWORD")

    parser.add_option("-P", "--port", dest="port", type="int",
                    help="RabbitMQ port.", metavar="PORT")

    parser.add_option("-v", "--vhost", dest="vhost", default='/',
                    help="RabbitMQ virtual host.", metavar="VHOST")

    parser.add_option("-s", "--ssl", dest="ssl", action="store_true", default=False,
                    help="Use SSL.")

    parser.add_option("-n", "--count", dest="count", type="int", default=1,
                    help="Queue N messages (adds a number to message text).", metavar="N")

    parser.add_option("--ha", dest="ha", action="store_true", default=False,
                    help="Use HA queue: Actually just prepends ha. in the queue name.")

    parser.add_option("-q", "--queue", dest="queue", default="task_queue",
                    help="RabbitMQ queue to connect to.", metavar="QUEUE")

    parser.add_option("-w", "--worker",
                    action="store_true", dest="worker", default=False,
                    help="Act as a RabbitMQ worker (consumer).")

    parser.add_option("-r", "--random-task-weight",
                    action="store_true", dest="random", default=False,
                    help="Create messages with random number of dots.")

    parser.add_option("--random-max", dest="random_max", type="int", default=5,
                    help="Max random weight.", metavar="N")

    parser.add_option("--random-min", dest="random_min", type="int", default=0,
                    help="Min random weight.", metavar="N")

    (options, args) = parser.parse_args()
    if len(args) == 0:
        parser.error('Missing argument. The URL to connect to is required.')
    if options.ha:
        options.queue = 'ha.' + options.queue
    if not options.password:
        options.password = getpass.getpass("%s's password: " % options.user)
    if not options.port:
        if options.ssl:
            options.port = 5671
        else:
            options.port = 5672

    credentials = pika.PlainCredentials(options.user, options.password)
    parameters = pika.ConnectionParameters(args[0], options.port, options.vhost, credentials, ssl=options.ssl)
    connection = pika.BlockingConnection(parameters)
    channel = connection.channel()
    channel.queue_declare(queue=options.queue, durable=True)

    if options.worker:
        consume(channel, options)
    else:
        message = ' '.join(args[1:]) or "Hello World!"
        publish(channel, options, message)
        connection.close()
