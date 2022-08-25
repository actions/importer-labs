using System;

namespace Attendees
{
    public class Attendee
    {
        public bool AddAttendee(string added)
        {
            if (added == "exists")
                return true;

            return false;
        }
    }
}
